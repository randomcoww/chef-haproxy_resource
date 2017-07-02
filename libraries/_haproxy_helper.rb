module HaproxyHelper

  class ConfigGenerator
    ## convert hash to yaml like config that unbound and nsd use

    ## sample source config
    # {
    #   'global' => {
    #     'user' => 'haproxy',
    #     'group' => 'haproxy',
    #     'log' => '127.0.0.1 local0',
    #     'log-tag' => 'haproxy',
    #     'daemon' => nil,
    #     'quiet' => nil,
    #     'stats' => [
    #       'socket /var/run/haproxy.sock user haproxy group haproxy',
    #       'timeout 2m'
    #     ],
    #     'maxconn' => 1024,
    #     'pidfile' => '/var/run/haproxy.pid'
    #   },
    #   'defaults' => {
    #     'timeout' => [
    #       'connect 5000ms',
    #       'client 10000ms',
    #       'server 10000ms'
    #     ],
    #     'log' => 'global',
    #     'mode' => 'tcp',
    #     'balance' => 'roundrobin',
    #     'option' => [
    #       'dontlognull',
    #       'redispatch'
    #     ],
    #     'stats' => 'uri /haproxy-status'
    #   },
    #   'frontend mysql' => {
    #     'default_backend' => 'mysql',
    #     'bind' => '*:3306',
    #     'maxconn' => 2000
    #   },
    #   'backend mysql' => {
    #     'mysql-ndb1' => '192.168.62.213:3306 check',
    #     'mysql-ndb2' => '192.168.62.214:3306 check'
    #   }
    # }

    def self.generate_from_hash(config_hash)
      g = new
      out = []

      config_hash.each do |k, v|
        g.parse_config_object(out, k, v, '')
      end
      return out.join($/)
    end

    def parse_config_object(out, k, v, prefix)
      case v
      when Hash
        out << [prefix, k].compact.join
        v.each do |e, f|
          parse_config_object(out, e, f, prefix + '  ')
        end

      when Array
        v.each do |e|
          parse_config_object(out, k, e, prefix)
        end

      when NilClass
        out << [prefix, k].join

      else
        out << [prefix, k, ' ', v].join
      end
    end
  end
end
