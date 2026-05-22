SET pause OFF
SET feedback ON
SET TIME ON
SET timing ON


WHENEVER SQLERROR EXIT failure ROLLBACK

-- Stats for DA
begin
    dbms_stats.gather_table_stats(
        ownname             => null,
        tabname             => 'INF_B_DA_MNTH_MCO_CLMTYP',
        granularity         => 'global',
        estimate_percent    => 100,
        cascade             => true,
        degree              => 16,
        force               => true,
        method_opt          => 'for all columns size 254',
        no_invalidate       => true
    );
end;
/

begin
    dbms_stats.gather_table_stats(
        ownname             => null,
        tabname             => 'INF_B_DA_MNTH_MCO_ACO_CLMTYP',
        granularity         => 'global',
        estimate_percent    => 100,
        cascade             => true,
        degree              => 16,
        force               => true,
        method_opt          => 'for all columns size 254',
        no_invalidate       => true
    );
end;
/

begin
    dbms_stats.gather_table_stats(
        ownname             => null,
        tabname             => 'INF_B_DA_MNTH_CLMNUM_MCO_CLMTYP',
        granularity         => 'global',
        estimate_percent    => 100,
        cascade             => true,
        degree              => 16,
        force               => true,
        method_opt          => 'for all columns size 254',
        no_invalidate       => true
    );
end;
/

begin
    dbms_stats.gather_table_stats(
        ownname             => null,
        tabname             => 'INF_B_DA_MNTH_CLMNUM_MCO_ACO_CLMTYP',
        granularity         => 'global',
        estimate_percent    => 100,
        cascade             => true,
        degree              => 16,
        force               => true,
        method_opt          => 'for all columns size 254',
        no_invalidate       => true
    );
end;
/

begin
    dbms_stats.gather_table_stats(
        ownname             => null,
        tabname             => 'INF_B_DA_MNTH_UTIL_MEM_MCO_CLMTYP',
        granularity         => 'global',
        estimate_percent    => 100,
        cascade             => true,
        degree              => 16,
        force               => true,
        method_opt          => 'for all columns size 254',
        no_invalidate       => true
    );
end;
/

begin
    dbms_stats.gather_table_stats(
        ownname             => null,
        tabname             => 'INF_B_DA_MNTH_UTIL_MEM_MCO_ACO_CLMTYP',
        granularity         => 'global',
        estimate_percent    => 100,
        cascade             => true,
        degree              => 16,
        force               => true,
        method_opt          => 'for all columns size 254',
        no_invalidate       => true
    );
end;
/

begin
    dbms_stats.gather_table_stats(
        ownname             => null,
        tabname             => 'INF_B_DA_MNTH_REVCDE_CLMNUM_MCO_CLMTYP',
        granularity         => 'global',
        estimate_percent    => 100,
        cascade             => true,
        degree              => 16,
        force               => true,
        method_opt          => 'for all columns size 254',
        no_invalidate       => true
    );
end;
/

begin
    dbms_stats.gather_table_stats(
        ownname             => null,
        tabname             => 'INF_B_DA_MNTH_MCO_ACO_BASE',
        granularity         => 'global',
        estimate_percent    => 100,
        cascade             => true,
        degree              => 16,
        force               => true,
        method_opt          => 'for all columns size 254',
        no_invalidate       => true
    );
end;
/

begin
    dbms_stats.gather_table_stats(
        ownname             => null,
        tabname             => 'INF_B_DA_MNTH_MCO_ACO_REVCDE_BASE',
        granularity         => 'global',
        estimate_percent    => 100,
        cascade             => true,
        degree              => 16,
        force               => true,
        method_opt          => 'for all columns size 254',
        no_invalidate       => true
    );
end;
/
