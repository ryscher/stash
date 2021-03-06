require 'active_record'
require 'stash/persistence_manager'
require 'models'

module Stash
  # PersistenceManager using ActiveRecord
  class ARPersistenceManager < PersistenceManager
    include Harvester::Models

    def db_status_for(index_status)
      case index_status
      when Indexer::IndexStatus::COMPLETED
        Status::COMPLETED
      when Indexer::IndexStatus::FAILED
        Status::FAILED
      else
        raise ArgumentError, "Unknown index status: #{index_status}"
      end
    end

    def begin_harvest_job(from_time: nil, until_time: nil, query_url:)
      HarvestJob.create(
        from_time: from_time,
        until_time: until_time,
        query_url: query_url,
        start_time: Time.now.utc,
        status: Status::IN_PROGRESS
      ).id
    end

    def record_harvested_record(harvest_job_id:, identifier:, timestamp:, deleted: false)
      HarvestedRecord.create(
        harvest_job_id: harvest_job_id,
        identifier: identifier,
        timestamp: timestamp,
        deleted: deleted
      ).id
    end

    def end_harvest_job(harvest_job_id:, status:)
      HarvestJob.find_by(id: harvest_job_id).update(
        end_time: Time.now.utc,
        status: db_status_for(status)
      )
    end

    def begin_index_job(harvest_job_id:, solr_url:)
      IndexJob.create(
        harvest_job_id: harvest_job_id,
        solr_url: solr_url,
        start_time: Time.now.utc,
        status: Status::IN_PROGRESS
      ).id
    end

    # TODO: should we pass both IDs in, or look up IJID from HRID?
    def record_indexed_record(index_job_id:, harvested_record_id:, status:)
      IndexedRecord.create(
        index_job_id: index_job_id,
        harvested_record_id: harvested_record_id,
        submitted_time: Time.now.utc, # TODO: is this right?
        status: db_status_for(status)
      )
    end

    def end_index_job(index_job_id:, status:)
      IndexJob.find_by(id: index_job_id).update(
        end_time: Time.now.utc,
        status: db_status_for(status)
      )
    end

    def find_newest_indexed_timestamp
      newest_indexed = HarvestedRecord.find_newest_indexed
      newest_indexed.timestamp if newest_indexed
    end

    def find_oldest_failed_timestamp
      oldest_failed = HarvestedRecord.find_oldest_failed
      oldest_failed.timestamp if oldest_failed
    end
  end
end
