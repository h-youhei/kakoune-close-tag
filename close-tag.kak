#use evaluate-commands to collapse undo
define-command close-tag %{ evaluate-commands %{
	#revert removing indent after leaving insert mode<a-l>
	try %{
		execute-keys -draft '<a-h>s[^\n]<ret>'
	} catch %{
		execute-keys -draft 'K<a-&>'
	}
	execute-keys ';Gg<a-;>'
	%sh{
		tag_list=`echo "$kak_selection" | grep -P -o '(?<=<)[^>]+(?=>)' | tac`
		close=
		close_stack=
		result=
		for tag in $tag_list ; do
			if [ `echo $tag | cut -c 1` = / ] ; then
				close=${tag#/}
				close_stack=$close\\n$close_stack
			else
				case $tag in
				#self-closing tags
				area|base|br|col|command|embed|hr|img|input|keygen|link|meta|param|source|track|wbr) continue ;;
				esac
				if [ $tag = $close ] ; then
					close_stack=${close_stack#*\\n}
					close=`echo $close_stack | head -n 1`
				else
					result=$tag
					break
				fi
			fi
		done
		[ -z $result ] && echo "fail 'no un-closed tag'"
		echo "set-register dquote </$tag>"
		echo "execute-keys ';<a-P>'"
		echo "try %{
			execute-keys -draft '<a-h>s<lt>$result><ret>'
		} catch %{
			execute-keys <
		}"
	}
}}
