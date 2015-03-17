module Meineke
  class DirectMailWorkflow < ::FusionWorkflow

    workflow do
      state :start do
        event :prepare_lists, transitions_to: :building_production_packages
      end
      state :building_production_packages do
        event :initialize_production_package, transitions_to: :building_production_order_and_client_detail_feed
      end
      state :building_production_order_and_client_detail_feed do
        event :create_production_order_and_client_detail_feed, transitions_to: :select_customers
      end
      state :selecting_customers do
        event :select_customers, transitions_to: :reviewing_results
      end
      state :reviewing_results do
        event :accept, transitions_to: :accepted
        event :reject, transitions_to: :rejected
      end
      state :accepted
      state :rejected
    end

    def prepare_lists
      puts "creating the production packages"
    end


  end
end
