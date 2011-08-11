Rails::Application.routes.draw do |map|
  match 'fckeditor/check_spelling' => 'fckeditor#check_spelling'
  match 'fckeditor/command' => 'fckeditor#command'
  match 'fckeditor/upload' => 'fckeditor#upload'
end
