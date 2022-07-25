function k9ss --argument ctx -d "k9s [ctx] with admin permission"
  if test -n "$ctx"
    echo "hello"
    k9s --as-group=system:masters --as admin --context="$ctx"
  else
    k9s --as-group=system:masters --as admin
  end
end
