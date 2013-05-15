use Rack::Session::Cookie, :user_id => nil,
                           :secret => 'in times of distress look no further than a box of teddy grahams',
                           :expire_after => 1800

get '/' do
  erb :index
end

post '/create_user' do
  erb :create_user
end

post '/secret' do
  @user = User.authenticate(params[:email],params[:password])
  if @user
    session[:user_id] = @user.id
    erb :secret
  else
    if params[:name]
      User.create!(:name => params[:name], :email => params[:email],
                 :password => params[:password])
    else
      redirect to '/'
    end
  end
end

get '/secret' do
  if session[:user_id]
    @user = User.where(:id => session[:user_id]).first
    erb :secret
  else
    redirect to '/'
  end
end
