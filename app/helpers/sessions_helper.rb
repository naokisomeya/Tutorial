module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  
  
  def current_user
    if (user_id = session[:user_id])                                            # 一時的なセッションユーザーがいる場合処理を行い、user_idに代入
      @current_user ||= User.find_by(id: user_id)                               # 現在のユーザーがいればそのまま、いなければsessionユーザーidと同じidを持つユーザーをDBから探して@current_user（現在のログインユーザー）に代入
    elsif (user_id = cookies.signed[:user_id])                                  # user_idを暗号化した永続的なユーザーがいる（cookiesがある）場合処理を行い、user_idに代入
      user = User.find_by(id: user_id)                                          # 暗号化したユーザーidと同じユーザーidをもつユーザーをDBから探し、userに代入
      if user && user.authenticated?(cookies[:remember_token])                  # DBのユーザーがいるかつ、受け取った記憶トークンをハッシュ化した記憶ダイジェストを持つユーザーがいる場合処理を行う
        log_in user                                                             # 一致したユーザーでログインする
        @current_user = user                                                    # 現在のユーザーに一致したユーザーを設定
      end
    end
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    log_out
    @current_user = nil
  end
  
  def remember(user)                                                            # rememberメソッドにuser(ログイン時にユーザーが送ったメールとパスと同一の、DBにいるユーザー)を引数として渡す
    user.remember                                                               # ログイン時のユーザーと同一のDBのユーザーに、記憶トークンを生成して記憶ダイジェストにハッシュ化したハッシュ値を持たせて保存
    cookies.permanent.signed[:user_id] = user.id                                # ログイン時のユーザーidを、有効期限(20年)と署名付きの暗号化したユーザーidとしてcookiesに保存
    cookies.permanent[:remember_token] = user.remember_token                    # ログイン時の記憶トークンを、有効期限（20年）を設定して新たなremember_tokenに保存。Userモデルにて、ログインユーザーと同一ならtrueを返す
  end
  
  def forget(user)                                                              # ログイン時に送ったuserのIDとパスワードと同一のユーザーを引数として渡す
    user.forget                                                                 # userに対してforgetメソッドを呼び出し、記憶ダイジェストをnilにする
    cookies.delete(:user_id)                                                    # cookiesのuser_idを削除
    cookies.delete(:remember_token)                                             # cookiesのremeber_tokenを削除
  end

  # ユーザーをログアウトする

  def log_out
    forget(current_user)                                                        # 引数として現在のログインユーザーを受け取り、forgetメソッドで記憶ダイジェストを削除
    session.delete(:user_id)                                                    # セッションのuser_idを削除する
    @current_user = nil                                                         # 現在のログインユーザーをnil（空に）する
  end
  
  def current_user?(user)
    user && user == current_user
  end
  
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?              # :forwarding_urlキーにリクエスト先のURLを、GETリクエストが送られた時だけ代入
  end
  
  
  
end
