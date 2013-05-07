require 'fileutils'
require 'sequel'

Sequel::Model.raise_on_save_failure = true
Sequel::Model.raise_on_typecast_failure = true
Sequel::Model.plugin :dataset_associations

require 'budget/action'
require 'budget/currency'
require 'budget/model'

Sequel.extension :inflector

module Budget

  class Manager

    include Action

    attr_reader :config

    def dispatch(args, mod = nil, default_action = 'summary')
      action, *action_args = args
      send :"action#{"_#{mod}" if mod}_#{action || default_action}", *action_args
    end

  end

end