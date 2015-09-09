//
//  AKStringResonator.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka on 9/9/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** A string resonator with variable fundamental frequency.

AKStringResonator passes the input through a network composed of comb, low-pass and all-pass filters, similar to the one used in some versions of the Karplus-Strong algorithm, creating a string resonator effect. The fundamental frequency of the “string” is controlled by the fundamentalFrequency.  This operation can be used to simulate sympathetic resonances to an input signal.
*/
@objc class AKStringResonator : AKParameter {

    // MARK: - Properties

    private var streson = UnsafeMutablePointer<sp_streson>.alloc(1)
    private var input = AKParameter()


    /** Fundamental frequency of string. [Default Value: 100.0] */
    var fundamentalFrequency: AKParameter = akp(100.0) {
        didSet { fundamentalFrequency.bind(&streson.memory.freq) }
    }

    /** Feedback amount (value between 0-1). A value close to 1 creates a slower decay and a more pronounced resonance. Small values may leave the input signal unaffected. Depending on the filter frequency, typical values are > .9. [Default Value: 0.95] */
    var feedbackFraction: AKParameter = akp(0.95) {
        didSet { feedbackFraction.bind(&streson.memory.fdbgain) }
    }


    // MARK: - Initializers

    /** Instantiates the filter with default values */
    init(input source: AKParameter)

    {
        super.init()
        input = source
        setup()
        bindAll()
    }

    /**
    Instantiates the filter with all values

    :param: input Input audio signal. 
    :param: fundamentalFrequency Fundamental frequency of string. [Default Value: 100.0]
    :param: feedbackFraction Feedback amount (value between 0-1). A value close to 1 creates a slower decay and a more pronounced resonance. Small values may leave the input signal unaffected. Depending on the filter frequency, typical values are > .9. [Default Value: 0.95]
    */
    convenience init(
        input                source:  AKParameter,
        fundamentalFrequency freq:    AKParameter,
        feedbackFraction     fdbgain: AKParameter)
    {
        self.init(input: source)

        fundamentalFrequency = freq
        feedbackFraction     = fdbgain

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal filter */
    internal func bindAll() {
        fundamentalFrequency.bind(&streson.memory.freq)
        feedbackFraction    .bind(&streson.memory.fdbgain)
    }

    /** Internal set up function */
    internal func setup() {
        sp_streson_create(&streson)
        sp_streson_init(AKManager.sharedManager.data, streson)
    }

    /** Computation of the next value */
    override func compute() -> Float {
        sp_streson_compute(AKManager.sharedManager.data, streson, &(input.value), &value);
        pointer.memory = value
        return value
    }

    /** Release of memory */
    override func teardown() {
        sp_streson_destroy(&streson)
    }
}