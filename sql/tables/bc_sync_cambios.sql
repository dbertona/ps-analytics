-- bc_sync_cambios — qué cambió en Seguimiento económico al sincronizar desde BC.
-- El backend compara el mes antes y después de reescribirlo y guarda solo la diferencia.
-- Autorizado: 2026-10-19 (tabla bc_sync_cambios).

CREATE TABLE IF NOT EXISTS public.bc_sync_cambios (
  id                   bigserial PRIMARY KEY,
  created_at           timestamptz NOT NULL DEFAULT now(),
  sync_id              uuid        NOT NULL,
  company_name         text        NOT NULL,
  entity               text        NOT NULL,
  year                 integer,
  month                integer,
  job_no               text,
  departamento         text,
  line_key             text,
  cambio               text        NOT NULL CHECK (cambio IN ('alta', 'baja', 'modificado')),
  venta_antes          numeric,
  venta_despues        numeric,
  coste_antes          numeric,
  coste_despues        numeric,
  usuario              text,
  origen               text        NOT NULL CHECK (origen IN ('usuario', 'proceso_automatico', 'no_identificado')),
  origen_job_no        text,
  origen_line_no       text,
  origen_requested_at  timestamptz
);

CREATE INDEX IF NOT EXISTS bc_sync_cambios_lookup_idx
  ON public.bc_sync_cambios (company_name, year, departamento, created_at DESC);

CREATE INDEX IF NOT EXISTS bc_sync_cambios_created_at_idx
  ON public.bc_sync_cambios (created_at);

COMMENT ON TABLE public.bc_sync_cambios IS
  'Diferencia de cada sincronización BC→Analytics (plan, mayor abierto, expediente, cierre). Retención 13 meses.';
