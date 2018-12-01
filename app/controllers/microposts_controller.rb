class MicropostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "メッセージを投稿しました。"
      redirect_to root_url
    else
      @microposts = current_user.microposts.order("created_at DESC").page(params[:page]) #どこから投稿してもparamsのpageは空ではないか？
      flash.now[:danger] = "メッセージの投稿に失敗しました。"
      render "toppages/index"
    end
  end

  def destroy
    # correct_userを通さないと、既存のidでログインさえしていれば他idの投稿を削除することが可能になる。
    @micropost.destroy
    flash[:success] = "メッセージを削除しました。"
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def micropost_params
    params.require(:micropost).permit(:content)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    # paramsは_micropost.html.erbのmicropost,microposts,index.html.erbの@microposts, toppages_controller.rbの@microposts
    #  この変数はcurrent_userから引っ張ってきてる。 ＃＃つまり、右辺がnilになることはないのではないか？＃＃
    
    #　↑　paramsをクライアントが任意に指定する場合(これは可能)に限りで、nilの可能性はある。
    # 削除リンクのあるページを表示しつつ、複窓でログアウトして他垢でログインし、その削除リンクを踏んだ場合もnilになる。
    # これはユーザーがparamsを弄ったりせず、普通に操作している時にも起こり得るパターン。↓開発者でない、普通のユーザー視点で見れば、下の操作はあったほうが自然だろう
    unless @micropost #これを加えればユーザー側がエラー画面を見せられる心配はない？　でも404とかは防げないだろう。　存在価値あるの？
    redirect_to root_url 
    end
  end
end
