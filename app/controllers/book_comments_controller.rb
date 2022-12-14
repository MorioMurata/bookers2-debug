class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    @comment.book_id = @book.id
    if @comment.save
      flash.now[:notice] = 'コメントを投稿しました'
      render :book_comments
    else
      render :book_comments
      #redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    BookComment.find(params[:id]).destroy

    @comment = BookComment.new
    @book = Book.find(params[:book_id])
    flash.now[:alert] = '投稿を削除しました'
    render :book_comments
    #redirect_back(fallback_location: root_path)
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
