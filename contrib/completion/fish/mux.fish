function __mux_has_command_token_count -d 'Tokens that are not options or option values'
    set -l cmd (commandline -poc)
    set cmd (string replace -r -- '((-[dE]\s?)|(-[cnxy] \S+\s?))+' '' $cmd)
    set -l tokens (string split ' ' (string trim $cmd))
    set -e tokens[1]
    test (count $tokens) -eq $argv[1]
end

function __mux_has_session
    __fish_seen_subcommand_from (__mux_tmux_sessions)
end

function __mux_tmux_sessions
    tmux list-sessions | string match -r '[^\s:]+'
end

complete -c mux -n '__mux_has_command_token_count 0' -x -a '(__mux_tmux_sessions)' -d 'Session'
complete -c mux -n 'not __mux_has_session; and __mux_has_command_token_count 1' -x -a '(__fish_complete_command)'

complete -c mux -s d -d 'Detach session'
complete -c mux -s E -d "Don't update the environment"
complete -c mux -s c -r -d 'Working directory'
complete -c mux -s n -x -d 'Window name'
complete -c mux -s x -x -d 'Width'
complete -c mux -s y -x -d 'Height'
