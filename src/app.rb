# frozen_string_literal: true

require 'mysql2'

MYSQL_HOST = ENV.fetch('MYSQL_HOST')

def lambda_handler(event:, context:) # rubocop:disable Lint/UnusedMethodArgument
  client = Mysql2::Client.new(host: MYSQL_HOST, username: 'root')

  {
    'variables' => client.query('show variables').to_a
  }
end
