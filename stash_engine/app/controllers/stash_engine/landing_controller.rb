require_dependency 'stash_engine/application_controller'

module StashEngine
  class LandingController < ApplicationController
    include StashEngine.app.metadata_engine.constantize::LandingMixin

    def show
      render('not_available') && return if params[:id].blank?
      @type, @id = params[:id].split(':', 2)
      @identifiers = Identifier.where(identifier_type: @type).where(identifier: @id)
      render('not_available') && return if @identifiers.count < 1
      @id = @identifiers.first
      @resource = @id.last_submitted_resource
      render('not_available') && return if @resource.blank?
      @resource_id = @resource.id
      @resource.increment_views
      setup_show_variables(@resource_id) #sets up the specific metadata view variables from <meta_engine>::LandingMixin
      @page_title = @review.title.title
    end

    def data_paper
      #request.format = 'pdf'
      render('not_available') && return if params[:id].blank?
      @type, @id = params[:id].split(':', 2)

      @identifiers = Identifier.where(identifier_type: @type).where(identifier: @id)
      render('not_available') && return if @identifiers.count < 1
      @id = @identifiers.first
      @resource = @id.last_submitted_resource
      render('not_available') && return if @resource.blank?
      @resource_id = @resource.id

      # sets up the specific metadata view variables from <meta_engine>::LandingMixin
      # @resource, @review, @schema_org_ds
      setup_show_variables(@resource_id)
      # TODO: we need to fix the way we mixin/set up variables and the citation is too complicated to deal with
      pdf_meta = metadata_engine::ResourcesController::PdfMetadata.new(@resource, @id, plain_citation)

      # lots of problems getting all styles and javascript to load with wicked pdf
      # https://github.com/mileszs/wicked_pdf/issues/257
      # https://github.com/mileszs/wicked_pdf
      my_debug = params[:debug] ? true : false
      respond_to do |format|
        format.any(:html, :pdf){
          render pdf: @review.pdf_filename,
                 page_size: 'Letter',
                 title: @review.title_str,
                 javascript_delay: 3000,
                 #'use_xserver' => true,
                 margin: { top: 20, bottom: 20, left: 20, right: 20 },
                 header: {
                    left: pdf_meta.top_left,
                    right: pdf_meta.top_right,
                    font_size: 9,
                    spacing: 5},
                 footer: {
                     left: pdf_meta.bottom_left,
                     right: pdf_meta.bottom_right,
                     font_size: 9,
                     spacing: 5},
                 show_as_html: my_debug
        }
      end
    end

    # PATCH /dataset/doi:10.xyz/abc
    def update
      # TODO: is this right?
      params.require(:id)
      params.require(:record_identifier)

      id_param = params[:id]
      render(nothing: true, status: 400) && return if id_param.blank?

      record_identifier = params[:record_identifier]
      render(nothing: true, status: 400) && return if record_identifier.blank?

      type, id = id_param.split(':', 2)
      identifiers = Identifier.where(identifier_type: type).where(identifier: id)

      # TODO: should this be a 5xx?
      render(nothing: true, status: 404) && return if identifiers.count < 1
      id = identifiers.first

      resource = id.processing_resource
      render(nothing: true, status: 404) && return if resource.blank?

      repo = StashEngine::repository
      repo.harvested(resource: resource, record_identifier: record_identifier)

      # success but no content, see RFC 5789 sec. 2.1
      render(nothing: true, status: 204)
    end
  end
end
