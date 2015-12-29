#!/usr/bin/ruby

require "mysql"

begin
	  require './config/local_config.rb'
rescue LoadError
end


begin

    con = Mysql.new 'localhost', 'root', RbConfig.pwd, 'karaokend'

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


