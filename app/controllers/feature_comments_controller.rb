class FeatureCommentsController < ApplicationController
  def add_comment
    @feature_comment = FeatureComment.new
    @feature_comment.feature_id = params[:feature_id]
  end

  def create_comment
    @feature_comment = FeatureComment.new(params[:feature_comment])
    @feature_comment.user = current_user
    @feature = @feature_comment.feature
    @comments = @feature.feature_comments

    if @feature_comment.save
      update_user_edit_stats
    end
  end

  def cancel_add_comment
  end

  def destroy
    @feature_comment = FeatureComment.find(params[:id])
    @feature_comment.destroy

    redirect_to :controller => 'features', :action => 'show', :id => @feature_comment.feature
  end
end
