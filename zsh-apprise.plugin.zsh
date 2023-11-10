# Standardized $0 handling
# https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

declare zshApprisePluginDirectory="${0:h}"

function () {
    # Standardize options
    # https://wiki.zshell.dev/community/zsh_plugin_standard#standard-recommended-options
    builtin emulate -L zsh ${=${options[xtrace]:#off}:+-o xtrace}
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    # User customizable settings
    # Commented out ZSTYLE commands are to document settings that are used but not initialized here
    zstyle ':apprise:user-setting:*'    'notify-always-on-failure'                  'yes'
    zstyle ':apprise:user-setting:*'    'notify-only-unfocused'                     'no'
    zstyle ':apprise:user-setting:*'    'notify-unknown-focus'                      'yes'
    zstyle ':apprise:user-setting:*'    'notify-command-minimum-seconds'            30
    zstyle ':apprise:user-setting:*'    'notify-command-ignore-regex'               ''
    zstyle ':apprise:user-setting:*'    'notify-apprise-tag'                        ''
    zstyle ':apprise:user-setting:*'    'notify-desktop-notifier'                   ''
    zstyle ':apprise:user-setting:*'    'notification-title-generation-function'    'za-generate-notification-title'
    zstyle ':apprise:user-setting:*'    'notification-body-generation-function'     'za-generate-notification-body'

    # Internal settings
    zstyle ':apprise:internal:setting:*'    'plugin-directory'  "${zshApprisePluginDirectory}"

    function za-generate-notification-title() {
        ########################################################################
        ##  Setup function variables
        ########################################################################

        # Parameters
        local commandAsTyped="${1}"
        local commandAsExecutedLimited="${2}"
        local commandAsExecutedFull="${3}"
        local commandExitStatus="${4}"
        local commandExecutionSeconds="${5}"
        local windowFocused="${6}"

        ########################################################################
        ##  Output title
        ########################################################################

        printf '%s@%s' "${USER}" "${HOST}"
    } # za-generate-notification-title

    function za-generate-notification-body() {
        ########################################################################
        ##  Setup function variables
        ########################################################################

        # Parameters
        local commandAsTyped="${1}"
        local commandAsExecutedLimited="${2}"
        local commandAsExecutedFull="${3}"
        local commandExitStatus="${4}"
        local commandExecutionSeconds="${5}"
        local windowFocused="${6}"

        # Procedural variables
        local resultEmoji
        local executionHours
        local executionMinutes
        local executionSeconds

        ########################################################################
        ##  Compute body parts
        ########################################################################

        if [[ "${commandExitStatus}" -eq 0 ]]; then
            resultEmoji='\u2705'; # Green box with checkmark emoji
        else
            resultEmoji='\u274c'; # red cross mark emoji
        fi

        executionHours=$((commandExecutionSeconds/3600))
        executionMinutes=$((commandExecutionSeconds%3600/60))
        executionSeconds=$((commandExecutionSeconds%60))

        ########################################################################
        ##  Output body
        ########################################################################

        printf '%b (%02d:%02d:%02d)\n' "${resultEmoji}" "${executionHours}" "${executionMinutes}" "${executionSeconds}"
        printf '%s' "${commandAsTyped}"
    } # za-generate-notification-body

    function za-notify() {

        ########################################################################
        ##  Setup function variables
        ########################################################################

        # Parameters
        local commandAsTyped="${1}"
        local commandAsExecutedLimited="${2}"
        local commandAsExecutedFull="${3}"
        local commandExitStatus="${4}"
        local commandExecutionSeconds="${5}"
        local windowFocused="${6}"

        # Setting variables
        local notifyOnlyUnfocused
        local notifyUnknownFocus
        local notifyAlwaysOnFailure
        local notifyCommandMinimumSeconds
        local notifyCommandIgnoreRegex
        local notifyAppriseTag
        local notifyDesktopNotifier
        local titleGenerationFunction
        local bodyGenerationfunction

        # Procedural variables
        local notificationTitle
        local notificationBody

        ########################################################################
        ##  Store settings in local variables
        ########################################################################

        zstyle -b ':apprise:user-setting:*'    'notify-only-unfocused'                      notifyOnlyUnfocused
        zstyle -b ':apprise:user-setting:*'    'notify-unknown-focus'                       notifyUnknownFocus
        zstyle -b ':apprise:user-setting:*'    'notify-always-on-failure'                   notifyAlwaysOnFailure
        zstyle -s ':apprise:user-setting:*'    'notify-command-minimum-seconds'             notifyCommandMinimumSeconds
        zstyle -s ':apprise:user-setting:*'    'notify-command-ignore-regex'                notifyCommandIgnoreRegex
        zstyle -s ':apprise:user-setting:*'    'notify-apprise-tag'                         notifyAppriseTag
        zstyle -s ':apprise:user-setting:*'    'notify-desktop-notifier'                    notifyDesktopNotifier
        zstyle -s ':apprise:user-setting:*'    'notification-title-generation-function'     titleGenerationFunction
        zstyle -s ':apprise:user-setting:*'    'notification-body-generation-function'      bodyGenerationfunction

        ########################################################################
        ##  Determine if a notifcation should be sent
        ########################################################################

        # Check if there are any configured notifiers
        if [[ -z "${notifyAppriseTag}" ]] && [[ -z "${notifyDesktopNotifier}" ]]; then
            return 0
        fi

        # Do not skip notifications if command failed and always notifying failures
        if [[ "${commandExitStatus}" -eq 0 ]] || [[ notifyAlwaysOnFailure = 'no' ]]; then

            # Time based checks
            if [[ "${commandExecutionSeconds}" -lt "${notifyCommandMinimumSeconds}" ]]; then
                return 0
            fi

            # Focus based checks
            if [[ "${notifyOnlyUnfocused}" = 'yes' ]]; then
                if [[ "${windowFocused}" -eq 0 ]]; then
                    return 0
                elif [[ "${notifyUnknownFocus}" = 'no' ]] && [[ "${windowFocused}" -gt 1 ]]; then
                    return 0
                fi
            fi

            # Ignore regex command checks
            if [[ -n "${notifyCommandIgnoreRegex}" ]]; then
                if printf '%s' "${commandAsExecutedFull}" | grep -q -E "${notifyCommandIgnoreRegex}"; then
                    return 0
                fi
            fi
        fi

        ########################################################################
        ##  Get notification title and body
        ########################################################################

        notificationTitle="$(
            "${titleGenerationFunction}" \
                "${commandAsTyped}" \
                "${commandAsExecutedLimited}" \
                "${commandAsExecutedFull}" \
                "${commandExitStatus}" \
                "${commandExecutionSeconds}" \
                "${windowFocused}"
        )"

        notificationBody="$(
            "${bodyGenerationfunction}" \
                "${commandAsTyped}" \
                "${commandAsExecutedLimited}" \
                "${commandAsExecutedFull}" \
                "${commandExitStatus}" \
                "${commandExecutionSeconds}" \
                "${windowFocused}"
        )"

        ########################################################################
        ##  Send desktop notification (if configured)
        ########################################################################

        if [[ -n "${notifyDesktopNotifier}" ]]; then
            apprise \
                -t "${notificationTitle}" \
                -b "${notificationBody}" \
                "${notifyDesktopNotifier}" \
                1>/dev/null 2>&1 &!
        fi

        ########################################################################
        ##  Send tag based notifications (if configured)
        ########################################################################

        if [[ -n "${notifyAppriseTag}" ]]; then
            apprise \
                -t "${notificationTitle}" \
                -b "${notificationBody}" \
                --tag "${notifyAppriseTag}" \
                1>/dev/null 2>&1 &!
        fi

    }

    zsh-execute-after-command-add-functions za-notify
}

unset zshApprisePluginDirectory
