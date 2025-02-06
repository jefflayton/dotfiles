function fish_user_key_bindings
  set -g fish_key_bindings fish_vi_key_bindings
  fish_default_key_bindings -M insert
  fish_vi_key_bindings --no-erase insert
  bind -M insert -m default 'KJ' cancel repaint-mode
  bind -M visual -m default 'KJ' cancel repaint-mode 
end  
