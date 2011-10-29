module ActAsImportable
  extend ActiveSupport::Concern
  module InstanceMethods
    def render_error object
      render :status=>500, :text => object.errors.full_messages[0]
    end
    def respond object
      respond_to do |f|
        f.html {render :text => object.id}
        f.json {render :json => object.to_json}
        f.xml {render :xml  => object.to_xml}
      end
    end
  end
end