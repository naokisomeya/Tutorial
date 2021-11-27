module UsersHelper
  def gravatar_for(user, options = { size: 80 })                                #メソッドの定義と指定した２つの引数を渡す
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)                   #小文字化したuserメールをMD5でハッシュ化し、変数に代入
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"#gravatarのURLに変数展開,画像用の変数に代入
    image_tag(gravatar_url, alt: user.name, class: "gravatar")                  #画像を表示し、user.nameを画像が表示されない時用に、classにgravatarを指定)
  end
end
