# frozen_string_literal: true

[
  { name: 'EMPW-Suez-up', location: { lat: 29.981881, long: 32.545291 } },
  { name: 'EMPW-Suez-down', location: { lat: 29.981941, long: 32.549868 } }
].each { |company| Company.create(company) }