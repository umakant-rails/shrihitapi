class Admin::ChaptersController < ApplicationController
  before_action :authenticate_user!
  # before_action :verify_admin
  before_action :set_scripture
  before_action :set_chapter, only: %i[ show edit update destroy ]

  def index
    page = params[:page].present? ? params[:page] : 1

    is_section = params[:data_type] == 'section'

    get_chapters_by_data_type(is_section)

    render json: {
      scripture: @scripture,
      chapters: @chapters,
      sections: @sections,
      total_chapters: @total_chapters,
      current_page: page
    }
  end

  def create
    @chapter = @scripture.chapters.new(chapter_params)
    # @chapter = Chapter.new(chapter_params)
    
    if @chapter.save
      
      get_chapters_by_data_type(@chapter.is_section)

      render json: {
        chapters: @chapters,
        sections: @sections,
        total_chapters: @total_chapters,
        current_page: 1,
        notice: "#{@chapter.is_section ? 'Section': 'Chapter'} is created Successfully."
      }
    else
      render json: {
        chapter: @chapter.errors, 
        errors: @chapter.errors.full_messages 
      }
    end
  end

  def update
    is_section = @chapter.is_section
    if @chapter.update(chapter_params)
      get_chapters_by_data_type(is_section)

      render json: {
        chapter: @chapter,
        chapters: @chapters,
        sections: @sections,
        total_chapters: @total_chapters,
        current_page: 1,
        notice: "#{is_section ? 'Section': 'Chapter'} is updated Successfully."
      }
    else
      render json: {
        chapter: @chapter.errors, 
        errors: @chapter.errors.full_messages 
      }
    end
  end

  def destroy
    is_section = @chapter.is_section
    @chapter.destroy

    get_chapters_by_data_type(is_section)

    render json: {
      chapter: @chapter,
      chapters: @chapters,
      sections: @sections,
      total_chapters: @total_chapters,
      current_page: 1,
      notice: "#{is_section ? 'Section': 'Chapter'} is updated Successfully."
    }
  end
  
  def add_section_chapters
    @scriptures = Scripture.all
  end

  def remove_section_chapters
    @scriptures = Scripture.all
  end

  def get_sections
    @scripture = current_user.scriptures.find(params[:scripture_id]) rescue nil
    @sections = @scripture.sections rescue nil
    @chapters = @scripture.chapters.where("is_section is false and parent_id is null") rescue nil
  end

  def get_section_chapters
    @section = Chapter.find(params[:section_id])
    @chapters = @section.chapters
  end

  def add_chapters_in_section
    Chapter.where("id in (?)", params[:chapters]).update(parent_id: params[:section_id])
    @scripture = Scripture.find(params[:scripture_id])
    @chapters = @scripture.chapters.where("is_section is false and parent_id is null")
  end

  def remove_chapters_from_section
    Chapter.where("id in (?)", params[:chapters]).update(parent_id: nil)
    @section = Chapter.find(params[:section_id]) rescue nil
    @chapters = @section.chapters rescue nil
  end  

  private

    def get_chapters_by_data_type(is_section)
      if is_section
        @chapters = @scripture.sections.order("index ASC").page(params[:page])
        @total_chapters = @scripture.sections.count
      else
        chapters_tmp = @scripture.chapters.order("index ASC").page(params[:page])

        @chapters = chapters_tmp && chapters_tmp.map do |chapter|
          chapter.attributes.merge({section: chapter.section ? chapter.section.name : '-'})
        end
        @total_chapters = @scripture.chapters.count
      end
      @sections = @scripture.sections
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chapter_params
      params.fetch(:chapter, {}).permit(:name, :is_section, :parent_id, :scripture_id, :index, :description)
    end

    def set_scripture
      @scripture = Scripture.find(params[:scripture_id])
    end

    def verify_admin
      if !current_user.is_admin && !current_user.is_super_admin
        redirect_back_or_to homes_path
      end
    end
end
