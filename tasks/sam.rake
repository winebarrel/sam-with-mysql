# frozen_string_literal: true

namespace :sam do
  namespace :local do
    task :invoke do
      sh 'sam', 'local', 'invoke', 'WithMySQLFunction',
         '-n', 'local-env.json',
         '--docker-network', 'sam-with-mysql'
    end
  end

  task :bundle do
    cd 'src' do
      sh 'docker', 'run',
         '-v', "#{pwd}:/mnt",
         '-w', '/mnt',
         'lambda-ruby-bundle:ruby2.5',
         'bash', '-c', <<~SH
           bundle install --path vendor/bundle && bundle clean
           # cf. https://docs.aws.amazon.com/lambda/latest/dg/lambda-environment-variables.html
           rm -f lib/*.so lib/*.so.*
           cp -p /usr/lib64/mysql57/libmysqlclient.so* lib/
         SH
    end
  end

  task package: :bundle do
    sh 'sam', 'package',
       '--template-file', 'template.yaml',
       '--output-template-file', 'packaged.yaml',
       '--s3-bucket', ENV.fetch('S3_BUCKET'),
       '--s3-prefix', 'sam-with-mysql'
  end

  task deploy: :package do
    sh 'sam', 'deploy',
       '--template-file', 'packaged.yaml',
       '--stack-name', 'sam-with-mysql',
       '--no-fail-on-empty-changeset',
       '--capabilities', 'CAPABILITY_IAM'
  end

  task :invoke do
    sh 'aws', 'lambda', 'invoke',
       '--function-name', 'sam-with-mysql',
       '/dev/stdout'
  end
end
