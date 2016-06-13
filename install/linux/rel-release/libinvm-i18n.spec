%define build_version 99.99.99.9999

Name:           libinvm-i18n
Version:        %{build_version}
Release:        1%{?dist}
Summary:        Internationalization library
License:        BSD
Group:          Development/Libraries
URL:            https://01.org/intel-nvm-i18n-library
Source:         https://github.com/01org/intelnvmi18nlibrary/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz

%description
Internationalization library

%package -n %{name}-devel
Summary:        Development files for %{name}
License:        BSD
Group:          Development/Libraries
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description -n %{name}-devel
The %{name}-devel package contains header files for
developing applications that use %{name}.

%prep
%setup -q -n %{name}-%{version}

%build
make BUILDNUM=%{build_version} RELEASE=1

%install
make install RELEASE=1 RPM_ROOT=%{buildroot} LIB_DIR=%{_libdir} INCLUDE_DIR=%{_includedir}

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%files
%doc README.md
%{_libdir}/libinvm-i18n.so.*
%license licenses/intel_bsd
%license licenses/netbsd

%files -n %{name}-devel
%doc README.md
%{_libdir}/libinvm-i18n.so
%{_includedir}/libinvm-i18n
%license licenses/intel_bsd
%license licenses/netbsd

%changelog
* Thu Mar 24 2016 Richard Johnson <richard.a.johnson@intel.com> - 1.0.0.1014-1
- Initial rpm release