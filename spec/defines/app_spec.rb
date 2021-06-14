# frozen_string_literal: true

require 'spec_helper'

describe 'unicorn::app' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'approot' => '/my/app',
      'pidfile' => '/my/pid',
      'socket'  => '/my/socket',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_service('unicorn_namevar') }

      case os_facts[:service_provider]
      when 'systemd'
        it { is_expected.to contain_systemd__unit_file('unicorn_namevar.service') }
      else

        case os_facts[:kernel]
        when 'Linux'
          it { is_expected.to contain_file('/etc/default/unicorn_namevar') }
          it { is_expected.to contain_file('/etc/init.d/unicorn_namevar') }
        when 'freebsd'
          it { is_expected.to contain_file('/usr/local/etc/rc.d/unicorn_namevar') }
        end
      end

      context 'with export_home => undef' do
        let(:params) do
          super().merge({ 'export_home' => :undef })
        end

        it { is_expected.to contain_unicorn__app('namevar').without_export_home }

        case os_facts[:kernel]
        when 'Linux'
          it { is_expected.to contain_file('/etc/init.d/unicorn_namevar').without_content('export HOME=') }
        end
      end

      context 'with export_home => \'\'' do
        let(:params) do
          super().merge({ 'export_home' => '' })
        end

        it { is_expected.to contain_unicorn__app('namevar').with_export_home('') }

        case os_facts[:kernel]
        when 'Linux'
          it { is_expected.to contain_file('/etc/init.d/unicorn_namevar').without_content('export HOME=') }
        end
      end
    end
  end
end
