class ResponseFactory
  def initialize(inflector, url)
    @inflector = inflector
    @url = url
  end

  def no_content_response
    header(:no_content)
  end

  def unauthorized_response
    header(:unauthorized) + errors_document([401, "Unauthorized"])
  end

  def forbidden_response
    header(:forbidden) + errors_document([403, "Forbidden"])
  end

  def not_found_response
    header(:not_found) + errors_document([404, "Not Found"])
  end

  def unprocessable_entity_response(message)
    header(:unprocessable_entity) + errors_document([422, message])
  end

  def server_error_response
    header(:server_error) + errors_document([500, "Internal Server Error"])
  end

  def person_response(id, name, phone_numbers_args = nil, code: :ok, include_phone_numbers: true)
    included = phone_numbers_args && include_phone_numbers ? phone_numbers_args.map { |args| phone_number_data(*args) } : []
    phone_number_ids = phone_numbers_args ? phone_numbers_args.map(&:first) : nil
    header(code) + document(person(id, name, phone_number_ids), included)
  end

  def people_response(*params, code: :ok)
    header(code) + document(people(*params))
  end

  def paginated_people_response(per_page, page, pages)
    first = per_page * (page - 1) + 1
    last = first - 1 + per_page
    params = (first..last).map { |i| [i.to_s, "Person#{i}"] }

    meta = {record_count: pages * per_page, page_count: pages}

    links = {
      first: "#{@url}/#{@inflector.encode_type(:person)}?page[number]=1&page[size]=#{per_page}",
      last: "#{@url}/#{@inflector.encode_type(:person)}?page[number]=#{pages}&page[size]=#{per_page}"
    }
    links[:next] = "#{@url}/#{@inflector.encode_type(:person)}?page[number]=#{page + 1}&page[size]=#{per_page}" if page < pages
    links[:prev] = "#{@url}/#{@inflector.encode_type(:person)}?page[number]=#{page - 1}&page[size]=#{per_page}" if page > 1

    header(:ok) + document(people(*params), [], meta, links)
  end

  def phone_number_response(id, name, number, contact_args = nil, code: :ok)
    included = contact_args ? [person_data(*contact_args)] : []
    contact_id = contact_args ? contact_args.first : nil
    header(code) + document(phone_number(id, name, number, contact_id), included)
  end

  def phone_numbers_response(*params, code: :ok)
    header(code) + document(phone_numbers(*params))
  end

private

  def person(*args)
    data(person_data(*args))
  end

  def people(*params)
    data(params.map { |args| person_data(*args) })
  end

  def person_data(id, name, phone_number_ids = nil)
    {
      id: id,
      type: @inflector.encode_type(:person),
      attributes: {
        name: name,
        email_address: "#{name.downcase}@example.com"
      },
      relationships: {
        phone_numbers: if phone_number_ids
          {
            data: ids(:phone_number, phone_number_ids)
          }
        else
          {
            links: {
              related: "#{@url}/#{@inflector.encode_type(:person)}/#{id}/#{@inflector.encode_key(:phone_numbers)}"
            }
          }
        end
      }
    }
  end

  def phone_number(*args)
    data(phone_number_data(*args))
  end

  def phone_numbers(*params)
    data(params.map { |args| phone_number_data(*args) })
  end

  def phone_number_data(id, name, phone_number, contact_id = nil)
    {
      id: id,
      type: @inflector.encode_type(:phone_number),
      attributes: {
        name: name,
        phone_number: phone_number
      },
      relationships: {
        contact: if contact_id
          {
            data: id(:person, contact_id)
          }
        else
          {
            links: {
              related: "#{@url}/#{@inflector.encode_type(:phone_number)}/#{id}/contact"
            }
          }
        end
      }
    }
  end

  def id(type, id)
    {type: @inflector.encode_type(type), id: id.to_s}
  end

  def ids(type, ids)
    ids.map { |i| id(type, i) }
  end

  def document(doc, included = [], meta = nil, links = nil)
    out = {jsonapi: {version: "1.0"}}
    out[:meta] = encode_value(meta) if meta
    out[:links] = links if links
    out = out.merge(doc)
    out[:included] = included unless included.empty?

    JSON.dump(out)
  end

  def errors_document(*args)
    JSON.dump(
      errors: args.map do |(status, detail)|
        {
          status: status,
          detail: detail
        }
      end
    )
  end

  def data(data)
    {data: encode_value(data)}
  end

  CODES = {
    ok: "200 OK".freeze,
    created: "201 Created".freeze,
    no_content: "204 No Content".freeze,
    unauthorized: "401 Unauthorized".freeze,
    forbidden: "403 Forbidden".freeze,
    not_found: "404 Not Found".freeze,
    unprocessable_entity: "422 Unprocessable Entity".freeze,
    server_error: "500 Internal Server Error".freeze
  }.freeze

  def header(code)
    "HTTP/1.1 #{CODES[code]}\nContent-Type: application/vnd.api+json\n\n"
  end

  def encode_value(value)
    if value.is_a?(Hash)
      value.each_with_object({}) do |(k, v), obj|
        obj[@inflector.encode_key(k)] = encode_value(v)
      end
    elsif value.is_a?(Array)
      value.map { |v| encode_value(v) }
    else
      value
    end
  end
end
