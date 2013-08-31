module ActionDispatch::Routing
  class Mapper
    def rapidfire_routes(controllers_hash = {})
      # merge with default controllers
      h = rapidfire_default_controllers.merge(controllers_hash)

      resources :question_groups, controller: h[:question_groups] do
        get 'results', on: :member

        resources :questions, controller: h[:questions]
        resources :answer_groups, only: [:new, :create], controller: h[:answer_groups]
      end
    end

    private
    def rapidfire_default_controllers
      {
        question_groups: "rapidfire/question_groups",
        questions:       "rapidfire/questions",
        answer_groups:   "rapidfire/answer_groups"
      }
    end
  end
end
