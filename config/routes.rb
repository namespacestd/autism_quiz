AnimeOpQuiz::Application.routes.draw do
    match "/" => "home#index", :via => [:get]
    match "/autocomplete" => "home#ajax_autocomplete", :via => [:get, :post]
    match "/admin/add_page" => "home#add_page", :via => [:get]
    match "/admin/add_page" => "home#test_url", :via => [:get]
    match "/admin/add_op_entry" => "home#add_op_entry", :via => [:post]
    match "/admin/add_op_entry_new" => "home#add_op_entry_new", :via => [:post]
    match "/submit_answer" => "home#submit_answer", :via => [:post]
    match "/test_url" => "home#test_url", :via => [:get]
    match "/retrieve_answer" => "home#retrieve_answer", :via => [:post]
    match "/alias" => "home#alias", :via => [:post]
end
