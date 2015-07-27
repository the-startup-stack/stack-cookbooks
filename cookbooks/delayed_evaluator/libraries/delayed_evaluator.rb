unless(defined?(Chef::DelayedEvaluator))
  class Chef::DelayedEvaluator < Proc
  end

  module DelayAllTheThings

    def lazy(&block)
      Chef::DelayedEvaluator.new(&block)
    end

    def delayed_set_or_return(symbol, arg, validation)
      iv_symbol = "@#{symbol.to_s}".to_sym
      map = {
        symbol => validation
      }
      if(arg.nil? && self.instance_variable_defined?(iv_symbol) == true)
        ivar = self.instance_variable_get(iv_symbol)
        if(ivar.is_a?(Chef::DelayedEvaluator))
          validate({ symbol => ivar.call }, { symbol => validation })[symbol]
        else
          ivar
        end
      else
        if(arg.is_a?(Chef::DelayedEvaluator))
          val = arg
        else
          val = validate({symbol => arg}, {symbol => validation})[symbol]
        end
        self.instance_variable_set(iv_symbol, val)
      end
    end

    def self.included(base)
      base.class_eval do
        alias_method :undelayed_set_or_return, :set_or_return
        alias_method :set_or_return, :delayed_set_or_return
      end
    end
  end

  unless(Chef::Mixin::ParamsValidate.ancestors.include?(DelayAllTheThings))
    Chef::Mixin::ParamsValidate.send(:include, DelayAllTheThings)
    Chef::Resource.send(:include, DelayAllTheThings)
  end

  Chef::Resource.constants.each do |con|
    klass = Chef::Resource.const_get(con)
    if(klass.is_a?(Class) && !klass.ancestors.include?(DelayAllTheThings) && klass.ancestors.include?(Chef::Mixin::ParamsValidate))
      klass.send(:include, DelayAllTheThings)
    end
  end
end
