function fish_prompt
     echo -n -s (set_color fcba03) $AWS_PROFILE (set_color 8cb0ff) "|" (kubectl config current-context) "|" (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (fish_git_prompt) " "
end

