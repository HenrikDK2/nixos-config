{
  programs.fish = {
    enable = true;

    shellAliases = {
      ns = "sudo nixos-rebuild switch -I nixos-config=$HOME/.nixos/configuration.nix";
    };

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';

    functions = {
      git = {
        description = "Wrapper around git that ensures global user.name/user.email are set";
        body = ''
          set -l git_name (command git config --global user.name 2>/dev/null)
          set -l git_email (command git config --global user.email 2>/dev/null)

          if test -z "$git_name"; or test -z "$git_email"
              set_color yellow
              echo "Git identity is not fully configured."
              set_color normal

              if test -z "$git_name"
                  read -P "  Username: " git_name
                  if test -n "$git_name"
                      command git config --global user.name "$git_name"
                  end
              end

              if test -z "$git_email"
                  read -P "  Email: " git_email
                  if test -n "$git_email"
                      command git config --global user.email "$git_email"
                  end
              end

              set_color green
              echo "Git identity set: $git_name <$git_email>"
              set_color normal
              echo ""
          end

          command git $argv
        '';
      };

      reset = {
        description = "Reset current branch to a selected commit and force-push";
        body = ''
          clear

          if not command -v git >/dev/null
              echo "Git is not installed. Please install Git and try again."
              return 1
          end

          echo -e "Recent commits:\n"
          git --no-pager log --pretty=format:"%ad | %h | %s" --abbrev-commit -n 20 --date=format:"%Y-%m-%d %H:%M"

          echo -e "\n"
          read -P "Enter the commit hash to reset to: " commit_hash

          if not git rev-parse "$commit_hash" >/dev/null 2>&1
              echo "❌ Invalid commit hash."
              return 1
          end

          echo "⚠️ This will reset your local branch to $commit_hash and force-push to origin. Continue? (y/N)"
          read -l confirm

          if test "$confirm" != "y"; and test "$confirm" != "Y"
              echo "❌ Aborted."
              return 1
          end

          git reset --hard "$commit_hash"; or return 1

          set branch_name (git rev-parse --abbrev-ref HEAD)
          git push origin "$branch_name" --force
        '';
      };

      push = {
        description = "Stage, commit and push changes";
        body = ''
          set status_output (git status)
          set diff_output (git diff)

          if test -z "$diff_output"; and not string match -q "*Changes to be committed*" $status_output
              git status
              return 1
          end

          if string match -q "*no changes added to commit*" $status_output
              git -C (git rev-parse --show-toplevel) add .
          end

          read -P "Commit message: " msg

          git commit -m "$msg"
          git push
          set cols (stty size | awk '{print $2}')
          printf '%*s\n' $cols ''' | tr ' ' '-'
          git status
        '';
      };

      zerotier-cli = {
        description = "Start zerotier-one if necessary before running zerotier-cli";
        body = ''
          set service zerotier-one

          sudo -v

          if not systemctl is-active --quiet $service
              sudo systemctl start $service
          end

          sudo zerotier-cli $argv
        '';
      };

      cd = {
        description = "cd with automatic Python virtualenv activation";
        body = ''
          builtin cd $argv

          if functions -q deactivate
              deactivate
          end

          if test -f bin/activate.fish; and type -q virtualenv; and type -q python
              source bin/activate.fish
          end
        '';
      };
    };
  };
}
