if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
    # Configuration for Amazon S3
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['S3_ACCESS_KEY'],
    :aws_secret_access_key  => ENV['S3_SECRET_KEY'],
    :region                 => 'us-west-2',
    :host                   => 'mynextgenhealth.s3-us-west-2.amazonaws.com',# optional, defaults to nil
    # :endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory      =  ENV['S3_BUCKET']
  config.fog_public         =  false
  config.fog_attributes     =  {'Cache-Control'=>'max-age=315576000'}
  config.storage            = :fog
  end
end
