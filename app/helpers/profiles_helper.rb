module ProfilesHelper
  def profiles_select_fields
    %i[name username github_url location organization].map do |field|
      [ Profile.human_attribute_name(field), field ]
    end
  end
end
