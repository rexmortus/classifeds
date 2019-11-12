class NotesController < ApplicationController

  before_action :set_note
  skip_before_action :authenticate_user!, :verify_authenticity_token
  
  def note_for_uuid
    render :json => @note.as_object
  end

  private

  def set_note
    @note = Note.find_by object_id: params[:uuid]
    unless @note.present?
      render json: { 'error': "Note #{params[:uuid]} found." }, status: 404
    end
  end

end
