#!/usr/bin/ruby

require 'mysql'
require 'yaml'

config = YAML.load_file('config/local.yml')
mysql = config['mysql']

begin

    con = Mysql.new mysql['server'], mysql['user'], mysql['pass'], mysql['db']

    rs = con.query("SELECT * FROM song")
    n_rows = rs.num_rows

    puts "There are #{n_rows} rows in the result set"

    n_rows.times do
        puts rs.fetch_row.join("\s")
    end

rescue Mysql::Error => e
    puts e.errno
    puts e.error

ensure
    con.close if con
end


