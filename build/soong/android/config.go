package android

// Global config used by Phantom soong additions
var PhantomConfig = struct {
	// List of packages that are permitted
	// for java source overlays.
	JavaSourceOverlayModuleWhitelist []string
}{
	// JavaSourceOverlayModuleWhitelist
	[]string{
		"org.phantom.hardware",
	},
}
