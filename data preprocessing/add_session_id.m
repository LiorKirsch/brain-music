function songs_counter = add_session_id(songs_id)

unique_songs = unique(songs_id);
[~, is_member] = ismember(songs_id, unique_songs );

unique_songs_counter = zeros(size(is_member));
songs_counter = zeros(size(unique_songs));
for i =1:length(is_member)
	current_id = is_member(i) ;
	unique_songs_counter(current_id) = unique_songs_counter(current_id) +1;
	songs_counter(i) = unique_songs_counter(current_id);
end

end
