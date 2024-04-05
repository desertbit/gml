pragma Singleton

import QtQuick

// Store is just a singleton wrapper around the Main store.
// The main store is its own component to simplify future testing, so we can then
// leave out the singleton.
Main {}
