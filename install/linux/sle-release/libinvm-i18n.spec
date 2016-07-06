%define build_version 99.99.99.9999

Name:           libinvm-i18n
Version:        %{build_version}
Release:        1%{?dist}
Summary:        Internationalization library
License:        BSD
Group:          Development/Libraries
URL:            https://01.org/intel-nvm-i18n-library
Source:         https://github.com/01org/libinvm-i18n/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz

%description
Framework library for Internationalization, supporting a subset of
Internationalization (I18n) functionality. This is a required library
for using libinvm-cli library.

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
%attr(755,root,root) %{_libdir}/libinvm-i18n.so.*
%license licenses/intel_bsd
%license licenses/netbsd

%files -n %{name}-devel
%doc README.md
%attr(755,root,root) %{_libdir}/libinvm-i18n.so
%attr(755,root,root) %dir %{_includedir}/libinvm-i18n
%attr(644,root,root) %{_includedir}/libinvm-i18n/*.h
%license licenses/intel_bsd
%license licenses/netbsd

%changelog
* Thu Mar 24 2016 Richard Johnson <richard.a.johnson@intel.com> - 1.0.0.1016-1
- Initial rpm release
