%define rpm_name libintelnvm-i18n
%define build_version 99.99.99.9999
%define build_release 1
%define dname %{rpm_name}-devel

Name:           %{rpm_name}
Version:		%{build_version}
Release:		%{build_release}%{?dist}
Summary:		Internationalization library
License:        BSD
Group:          Development/Libraries
URL:			http://www.intel.com
Source:         %{rpm_name}.tar.bz2

%define  debug_package %{nil}

%description
Internationalization library

%package -n %dname
Summary:        Development files for %{name}
License:        BSD
Group:          Development/Libraries
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description -n %dname
The %{name}-devel package contains header files for
developing applications that use %{name}.

%prep
%setup -q -n %{rpm_name}

%build
make BUILDNUM=%{build_version} RELEASE=1

%install
make install RELEASE=1 RPM_ROOT=%{buildroot} LIB_DIR=%{_libdir} INCLUDE_DIR=%{_includedir}

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%files
%attr(755,root,root) %{_libdir}/libintelnvm-i18n.so.*
%license licenses/intel_bsd

%files -n %dname
%attr(755,root,root) %{_libdir}/libintelnvm-i18n.so
%attr(755,root,root) %dir %{_includedir}/libintelnvm-i18n
%attr(644,root,root) %{_includedir}/libintelnvm-i18n/*.h
%license licenses/intel_bsd

%changelog
* Thu Mar 24 2016 richard.a.johnson@intel.com
- Initial rpm release
