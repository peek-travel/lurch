module LurchTest
  def setup
    # TODO: figure out how to run test suite multiple times with different setup, so we don't randomize like this
    inflection_mode = [:dasherize, :underscore].sample
    types_mode = [:pluralize, :singularize].sample

    @url = "http://example.com/api"
    @store = Lurch::Store.new(@url, inflection_mode: inflection_mode, types_mode: types_mode)
    @inflector = Lurch::Inflector.new(inflection_mode, types_mode)
    @response_factory = ResponseFactory.new(@inflector, @url)
  end

  def person_type
    @inflector.encode_type(:person)
  end

  def phone_number_type
    @inflector.encode_type(:phone_number)
  end

  def stub_get(path, response)
    stub_req(:get, path, response)
  end

  def stub_patch(path, response)
    stub_req(:patch, path, response)
  end

  def stub_post(path, response)
    stub_req(:post, path, response)
  end

  def stub_delete(path, response)
    stub_req(:delete, path, response)
  end

  def stub_req(method, path, response)
    stub_request(method, "#{@url}/#{path}").to_return(response)
  end
end
