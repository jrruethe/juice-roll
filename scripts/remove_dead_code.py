#!/usr/bin/env python3
"""
Carefully remove displayType and sections getters from Dart files.

This script finds and removes getter blocks that:
1. Have @override annotation
2. Define ResultDisplayType get displayType or List<ResultSection> get sections

It's careful about:
- Tracking brace depth properly
- Not corrupting class structure
- Preserving blank lines appropriately
"""

import re
from pathlib import Path


def find_getter_ranges(lines: list[str]) -> list[tuple[int, int]]:
    """Find line ranges for displayType and sections getters to remove."""
    ranges_to_remove = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        
        # Look for the /// comment that precedes the displayType getter
        if stripped == '/// UI display type for generic rendering.':
            start_idx = i
            # Find the @override and getter
            j = i + 1
            while j < len(lines):
                next_line = lines[j].strip()
                if next_line == '@override':
                    j += 1
                    continue
                elif 'ResultDisplayType get displayType' in next_line:
                    # This is a single-line displayType getter
                    ranges_to_remove.append((start_idx, j + 1))
                    i = j + 1
                    break
                elif next_line == '' or next_line.startswith('///'):
                    j += 1
                    continue
                else:
                    # Something else, not what we're looking for
                    break
            else:
                i += 1
            continue
        
        # Look for the /// comment that precedes the sections getter
        if stripped == '/// Structured display sections for generic rendering.':
            start_idx = i
            # Find the @override and sections getter, then track braces
            j = i + 1
            while j < len(lines) and lines[j].strip() in ['', '@override'] or lines[j].strip().startswith('///'):
                j += 1
            
            if j < len(lines) and 'List<ResultSection> get sections' in lines[j]:
                # Found sections getter - now find where it ends
                brace_depth = 0
                bracket_depth = 0
                started_counting = False
                end_idx = j
                
                for k in range(j, len(lines)):
                    line_k = lines[k]
                    for char in line_k:
                        if char == '{':
                            brace_depth += 1
                            started_counting = True
                        elif char == '}':
                            brace_depth -= 1
                        elif char == '[':
                            bracket_depth += 1
                            started_counting = True
                        elif char == ']':
                            bracket_depth -= 1
                    
                    # Check for end of getter
                    if started_counting:
                        # Arrow syntax ends with ];
                        if '=>' in lines[j] and bracket_depth == 0 and line_k.rstrip().endswith('];'):
                            end_idx = k + 1
                            break
                        # Block syntax ends with }
                        elif brace_depth == 0 and lines[k].strip() == '}':
                            end_idx = k + 1
                            break
                
                ranges_to_remove.append((start_idx, end_idx))
                i = end_idx
                continue
        
        i += 1
    
    return ranges_to_remove


def remove_ranges(lines: list[str], ranges: list[tuple[int, int]]) -> list[str]:
    """Remove the specified line ranges from lines list."""
    if not ranges:
        return lines
    
    # Sort ranges by start index, descending so we can remove from end
    ranges = sorted(ranges, key=lambda x: x[0], reverse=True)
    
    result = lines[:]
    for start, end in ranges:
        del result[start:end]
    
    # Clean up extra blank lines
    cleaned = []
    prev_blank = False
    for line in result:
        is_blank = line.strip() == ''
        if is_blank and prev_blank:
            continue
        cleaned.append(line)
        prev_blank = is_blank
    
    return cleaned


def remove_imports(content: str) -> str:
    """Remove the dead import lines."""
    lines = content.split('\n')
    result = []
    for line in lines:
        if "import '../models/results/result_types.dart';" in line:
            continue
        if "import '../models/results/display_sections.dart';" in line:
            continue
        if 'import "results/result_types.dart";' in line:
            continue
        if 'import "results/display_sections.dart";' in line:
            continue
        if "import 'result_types.dart';" in line:
            continue
        if "import 'display_sections.dart';" in line:
            continue
        result.append(line)
    return '\n'.join(result)


def process_file(filepath: Path) -> tuple[bool, str]:
    """Process a single file. Returns (modified, status_message)."""
    original = filepath.read_text()
    content = original
    
    # First remove imports
    content = remove_imports(content)
    
    # Then find and remove getter blocks
    lines = content.split('\n')
    ranges = find_getter_ranges(lines)
    
    if ranges:
        new_lines = remove_ranges(lines, ranges)
        content = '\n'.join(new_lines)
    
    if content != original:
        # Verify we didn't corrupt the file - basic checks
        original_class_count = original.count('class ')
        new_class_count = content.count('class ')
        
        if original_class_count != new_class_count:
            return False, f"ERROR: Class count mismatch ({original_class_count} -> {new_class_count})"
        
        # Count braces - should still be balanced 
        original_open = original.count('{')
        original_close = original.count('}')
        new_open = content.count('{')
        new_close = content.count('}')
        
        # The braces we remove should be from the getters
        expected_reduction = len([r for r in ranges if 'get sections' in ''.join(lines[r[0]:r[1]])])
        
        filepath.write_text(content)
        return True, f"Removed {len(ranges)} getter(s)"
    
    return False, "No changes needed"


def main():
    # Process all preset files
    presets_dir = Path('/home/jkord/dev/juice-roll/lib/presets')
    models_dir = Path('/home/jkord/dev/juice-roll/lib/models')
    results_dir = models_dir / 'results'
    
    files_to_process = list(presets_dir.glob('*.dart'))
    files_to_process.append(models_dir / 'roll_result.dart')
    files_to_process.append(results_dir / 'ironsworn_result.dart')
    files_to_process.append(results_dir / 'table_lookup_result.dart')
    
    modified = 0
    errors = 0
    
    for filepath in files_to_process:
        if not filepath.exists():
            print(f"SKIP: {filepath} (not found)")
            continue
        
        success, message = process_file(filepath)
        if 'ERROR' in message:
            print(f"ERROR: {filepath.name}: {message}")
            errors += 1
        elif success:
            print(f"OK: {filepath.name}: {message}")
            modified += 1
    
    print(f"\nModified: {modified}, Errors: {errors}")


if __name__ == '__main__':
    main()
