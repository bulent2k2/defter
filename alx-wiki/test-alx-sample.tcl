# This is <sandbox>/test/alx/sample.tcl
namespace eval t {}
proc doc_test_alx_sample {} { set list {
    #
    # This file defines some new apis to help speed up testing related activities:
    #   
    #    load or create new lay-a, the input layout data
    #    run {alx setup}
    #    generate lay-b by running {alx migrate}
    #

    Sometimes it is best to start with an example.

    Here is how to create and run a simple test {
        % mkdir scratch; cd scratch
        % cvs co -l test/alx
        % gtcl 
        > source test/alx/init.tcl
        > t::boot
        > t::load_samples
        > t::sample_test
        # Or, run on a sub-cell from one of the libraries from ALX DRC regressions:
        > set libs [t::sample_libs]
        > t::sample_run [lindex $libs 1] ; # or pick any other lib from the list
    }

    Now, please see the definition of the tcl-proc t::sample_test which, 
    hopefully, you were able run successfully by following the steps above. 
    Otherwise, please try them now before going forward.

    You can see the details using {
        pp t::sample_test
        # which uses:
        pp t::sample_z
        # which uses:
        pp t::new_rect
    }

    Now, moving on for more information on other API..

    #
    # The API are classified as follows
    #
    t::new_* {
        lib   -- Create a new lib
        cell  -- Create a new cell
        rect  -- Create a new rect
    }

    t::sample_* {
        test    -- Create a new test-case and run {alx migrate} on it. Please try it!
        cfg     -- Path to tsmcN45_LDP.cfg
        libs    -- Names of titan libraries (from GDS) that make up ALX DRC regressions
        run     -- Setup and run ALX on a small sub-cell from the very first customer testcase
        setup   -- Sample setup for Prism's gto design
        input   -- Sample data from Prism's gto design
        flow    -- Use the sample setup and input above to run {alx migrate}
        use_new -- Call this to test new flow and options
        z       -- Create a z topology
        sym_z   -- Create a pair of z topologies
    }

    t::reg_data_* {
        load       -- Load a lib and a cell. If necessary, checks it out from CVS.
        cvs_path   -- The local path to the regression library in CVS.
        archive    -- Check it out into this sub-dir
        co         -- Check out the reg libs and untar the given lib
        setup_info -- Given a lib, return techa, scaling factors, the/a top cell, a sample sub-cell
    }

} }
