{ pkgs, config }:

pkgs.writeShellApplication {
  name = "rofi-pulse";
  checkPhase = "";

  runtimeInputs = with pkgs; [ coreutils gnugrep ponymix rofi gawk ];

  text = ''
      function usage {
          echo "Usage:"
          echo

          echo "To change the default output (e.g., speaker):"
          echo "\$ $0 sink"

          echo

          echo "To change the default input (e.g., microphone):"
          echo "\$ $0 source"
      }

      function read_arguments {
          if [[ ! $# -eq 1 ]]; then
              usage >&2
              exit 1
          fi

          local type="$1"

          if [[ ! "$type" =~ (sink|source) ]]; then
              usage >&2
              exit 1
          fi

          echo "$type"
      }

      function formatlist {
          awk "/^$type/ {s=\$1\" \"\$2;getline;gsub(/^ +/,\"\",\$0);print s\" \"\$0}"
      }

      function select_target {
          local list
          local default
          local default_row

          local type=$1
          local icon

          list=$(ponymix -t "$type" list | formatlist)
          default=$(ponymix defaults | formatlist)

          # line number of default in list (note: row starts at 0)
          default_row=$(echo "$list" | grep -nr "$default" - | cut -f1 -d: | awk '{print $0-1}')
        
          if [ "$type" == "sink" ]; then
            icon=""
          else
            icon=""
          fi

          echo "$list" \
              | rofi -dmenu -theme launcher -p "$icon" -theme-str 'window {width: 800px;}' -selected-row "$default_row" \
              | grep -Po '[0-9]+(?=:)'
      }

      function set_default {
          local type="$1"
          local device="$2"
          ponymix set-default -t "$type" -d "$device"
      }

      function move_all_streams {
          local type=$1

          case "$type" in
              sink)
                  for input in $(ponymix list -t sink-input|grep -Po '[0-9]+(?=:)'); do
                               echo "moving stream sink $input -> $device"
                               ponymix -t sink-input -d "$input" move "$device"
                  done
                  ;;

              source)
                  for output in $(ponymix list -t source-output | grep -Po '[0-9]+(?=:)'); do
                      echo "moving stream source $output <- $device"
                      ponymix -t source-output -d "$output" move "$device"
                  done
                  ;;
          esac
    }

    function main {
        local type
        local device

        type=$(read_arguments "$@")
        device=$(select_target "$type")

        set_default "$type" "$device"

        move_all_streams "$type"
    }

    main "$@"
  '';
}
