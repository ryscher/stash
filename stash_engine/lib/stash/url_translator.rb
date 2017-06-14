module Stash
  class UrlTranslator
    # a class to translate URLs to direct download links for cloud services.

    # test links
    # google_drive: https://drive.google.com/file/d/0B9diV3DhsADzQ2Q2aDZGRFlkLVU/view?usp=sharing
    # google_doc: https://docs.google.com/document/d/1vrQrKYAWVS9PeQHhOy9mcvDTvhgq85KCndScfrERHBk/edit?usp=sharing
    # google_presentation: https://docs.google.com/presentation/d/1w_S-nfMOnIUob_QqkWkQ-FrbUdQm0tr6X-CqvqOu-yc/edit?usp=sharing
    # google_sheet: https://docs.google.com/spreadsheets/d/1wUMpgSivZyCxqHMpnlJ5uvNcgQY8XvH1_3WBH7kvXjE/edit?usp=sharing
    # dropbox: https://www.dropbox.com/s/j84vdgcht1rxygb/generic_logo.svg?dl=0
    # box: https://ucop.box.com/s/o39s94g28puss5ttt7vss8b0qrlge184
    # non-mapped: http://www.koalastothemax.com/


    GOOGLE_DRIVE = /^https:\/\/drive\.google\.com\/file\/d\/(\S+)\/(?:view|edit)(?:\?usp=sharing)?$/
    GOOGLE_DOC = /^https:\/\/docs\.google\.com\/document\/d\/(\S+)\/edit(?:\?usp=sharing)?$/
    GOOGLE_PRESENTATION = /^https:\/\/docs\.google\.com\/presentation\/d\/(\S+)\/edit(?:\?usp=sharing)?$/
    GOOGLE_SHEET = /^https:\/\/docs\.google\.com\/spreadsheets\/d\/(\S+)\/edit(?:\?usp=sharing)?$/
    DROPBOX = /^https:\/\/www\.dropbox\.com\/s\/(\S+)\/([^\/]+)(?:\?dl=[0-9]+)$/
    BOX = /^https:\/\/([^\/]+box\.com)\/s\/(\S+)$/

    attr_reader :service, :direct_download

    def initialize(url)
      @url = url
      service = nil

      %w{google_drive google_doc google_presentation google_sheet dropbox box}.each do |m|
        if @direct_download = send(m)
          @service = m
          @service = 'google' if m.start_with?('google')
          break
        end
      end
    end

    private
    # these returns are supposed to be assignment, and not equality (==) because I want to check and assign at once
    def google_drive
      return nil unless m = GOOGLE_DRIVE.match(@url)
      "https://drive.google.com/uc?export=download&id=#{m[1]}"
    end

    def google_doc
      return nil unless m = GOOGLE_DOC.match(@url)
      "https://docs.google.com/document/d/#{m[1]}/export?format=doc"
    end

    def google_presentation
      return nil unless m = GOOGLE_PRESENTATION.match(@url)
      "https://docs.google.com/presentation/d/#{m[1]}/export/pptx"
    end

    def google_sheet
      return nil unless m = GOOGLE_SHEET.match(@url)
      "https://docs.google.com/spreadsheets/d/#{m[1]}/export?format=xlsx"
    end

    def dropbox
      return nil unless m = DROPBOX.match(@url)
      "https://dl.dropboxusercontent.com/s/#{m[1]}/#{m[2]}"
    end

    def box
      return nil unless m = BOX.match(@url)
      "https://#{m[1]}/shared/static/#{m[2]}"
    end

  end
end