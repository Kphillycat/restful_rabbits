require 'bundler'
Bundler.require
require './lib/rabbits'

  #all rabbits
  get '/' do
    @rabbits = Rabbit.all
    haml :index
  end

  #add new rabbit
  get '/rabbits/new' do
    @rabbit = Rabbit.new
    haml :new
  end

  #create a new rabbit
  post '/rabbits/new' do
    @rabbit = Rabbit.new(params[:rabbit])
    if @rabbit.save #checks if params are valid by trying to save
      status 201 #created
      redirect '/rabbits/' + @rabbit.id.to_s
    else
      status 400 #Bad request
      haml :new
    end
  end

  #edit rabbit
  get '/rabbits/edit/:id' do
    @rabbit = Rabbit.find(params[:id])
    haml :edit
  end

  put '/rabbits/:id' do
    @rabbit = Rabbit.find(params[:id])
    if @rabbit.update(params[:rabbit])
      status 201
      redirect '/rabbits/' + params[:id]
    else
      status 400
      haml :edit
    end
  end

  # delete confirmation page
  get '/rabbits/delete/:id' do
    @rabbit = Rabbit.find(params[:id])
    haml :delete
  end

  #real delete sent from delete.erb
  delete '/rabbits/:id' do
    Rabbit.find(params[:id]).delete
    redirect '/' #index page
  end

  #Sinatra goes thru the routes in the order they appear
  #Show rabbit
  get '/rabbits/:id' do
    @rabbit = Rabbit.find(params[:id])
    haml :show
  end

__END__
@@layout
!!! 5
%html
  %head
    %meta(charset="utf-8")
    %title Rabbits
  %body
    = yield

@@index
%h3 Rabbits
%a(href="/rabbits/new") Create a new rabbit
- unless @rabbits.empty?
  %ul#rabbits
  - @rabbits.each do |rabbit|
    %li{:id => "rabbit-#{rabbit.id}"}
      %a(href="/rabbits/#{rabbit.id}")= rabbit.name
      %a(href="/rabbits/edit/#{rabbit.id}") EDIT
      %a(href="/rabbits/delete/#{rabbit.id}") DELETE
- else
  %p No rabbits!

@@show
%h3= @rabbit.name
%p Color: #{@rabbit.color}
%p Age: #{@rabbit.age}
%p Description: #{@rabbit.description}
%p Created at: #{@rabbit.created_at}
%p Last updated at: #{@rabbit.updated_at}
%a(href="/rabbits/edit/#{@rabbit.id}")EDIT
%a(href="/rabbits/delete/#{@rabbit.id}")DELETE
%a(href='/') Back to index

@@new
= haml :errors, :layout => false
%form(action="/rabbits/new" method="POST")
  %fieldset
    %legend Create a new rabbit
    = haml :form, :layout => false
  %input(type="submit" value="Create") or <a href='/'>cancel</a>  
  
@@edit
= haml :errors, :layout => false
%form(action="/rabbits/#{@rabbit.id}" method="POST")
  %input(type="hidden" name="_method" value="PUT")
  %fieldset
    %legend Update this rabbit
    = haml :form, :layout => false
  %input(type="submit" value="Update") or <a href='/'>cancel</a>

@@form
%label(for="name")Name:
%input#name(type="text" name="rabbit[name]"value="#{@rabbit.name}")

%label(for="color")Color:
%select#color(name="rabbit[color]")
  - %w[black white grey brown].each do |color|
    %option{:value => color, :selected => (true if color == @rabbit.color)}= color
    
%label(for="description") Description:
%textarea#description(name="rabbit[description]")
  =@rabbit.description
  
%label(for="age") Age:
%input#age(type="text" name="rabbit[age]"value="#{@rabbit.age}")

@@errors
-if @rabbit.errors.any?
  %ul#errors
  -@rabbit.errors.each do |error|
    %li= error

@@delete
%h3 Are you sure you want to delete #{@rabbit.name}?
%form(action="/rabbits/#{@rabbit.id}" method="post")
  %input(type="hidden" name="_method" value="DELETE")
  %input(type="submit" value="Delete") or <a href="/">Cancel</a>
