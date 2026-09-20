// Example long path
const fullPath = "/very/very/long/long/to/some/path/";

// Function to truncate the path
function truncatePath(path, segmentsToKeep = 2) {
    // Split the path into segments
    const segments = path.split('/').filter(segment => segment.length > 0);

    // Keep only the last `segmentsToKeep` segments
    const truncatedSegments = segments.slice(-segmentsToKeep);

    // Join the segments back into a path
    return truncatedSegments.join('/') + '/';
}

// Truncate the path
const truncatedPath = truncatePath(fullPath);
console.log(truncatedPath); // Output: "some/path/"
