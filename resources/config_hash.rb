property :path, String, required: true
property :key, String, required: true
property :value, String

action_class do
  def get_value
    powershell_out("Import-Module WebAdministration; Get-WebConfigurationProperty -Filter #{path} -Name #{key}").stdout.chop
  end

  def value_exist?
    get_value != ''
  end
end


load_current_value do
  current_value_does_not_exist! unless value_exist?
  value get_value
end

action :set do
  converge_if_changed do
    powershell "Import-Module WebAdministration; Set-WebConfigurationProperty -Filter #{path} -Name #{key} -Value #{value}"
  end
end

action :remove do
  if value_exist?
    powershell "Import-Module WebAdministration; Remove-WebConfigurationProperty -Filter #{path} -Name #{key}"
  end
end
