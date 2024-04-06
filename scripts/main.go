package main

import (
	"bytes"
	"fmt"
	"io/fs"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"slices"
	"strings"
	"unicode"
)

func main() {
	err := run()
	if err != nil {
		log.Fatal(err)
	}
}

var (
	regexImport = regexp.MustCompile(`import Action\.\w+ as (A\w+)\n`)
	regexAction = regexp.MustCompile(`A\.A(\w+)\.`)
)

func run() error {
	return filepath.WalkDir("../qml/Main.qml", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if !d.Type().IsRegular() || !strings.HasSuffix(path, ".qml") {
			return nil
		}

		// Read the file content.
		content, err := os.ReadFile(path)
		if err != nil {
			return fmt.Errorf("read file '%s': %v", path, err)
		}

		const importStmt = "import Action as A\n"
		if bytes.Contains(content, []byte(importStmt)) {
			return nil
		}

		matches := regexImport.FindAllSubmatchIndex(content, -1)
		if matches == nil {
			return nil
		}

		modules := make([]string, 0)
		for _, match := range matches {
			if len(match) != 4 {
				return fmt.Errorf("match has invalid length %d: %+v", len(match), match)
			}

			// Add to the modules map.
			id := string(content[match[2]:match[3]])
			if !slices.Contains(modules, id) {
				modules = append(modules, id)
			}
		}
		content = regexImport.ReplaceAll(content, []byte{})

		for _, mod := range modules {
			replace := []byte{'A', '.'}
			replace = append(replace, []byte(mod)...)
			content = bytes.ReplaceAll(content, []byte(mod), replace)
		}

		content = bytes.Replace(content, []byte("\nimport Lib as L"), []byte("import Action as A\nimport Lib as L"), -1)

		/*modules := make([]string, 0)
		for {
			match := regexAction.FindSubmatchIndex(content)
			if match == nil {
				break
			} else if len(match) != 4 {
				return fmt.Errorf("match has invalid length %d: %+v", len(match), match)
			}

			// Add to the modules map.
			id := string(content[match[2]:match[3]])
			if !slices.Contains(modules, id) {
				modules = append(modules, id)
			}

			// Replace the module call.
			replace := []byte{'A'}
			replace = append(replace, content[match[2]:match[3]]...)
			replace = append(replace, '.')
			content = append(content[:match[0]], content[match[1]:]...)
			content = slices.Insert(content, match[0], replace...)
		}

		slices.Sort(modules)

		// Generate the new imports.
		var header bytes.Buffer
		for _, id := range modules {
			header.WriteString(fmt.Sprintf("import Action.%s as A%s\n", id, id))
		}
		header.WriteByte('\n')
		content = bytes.Replace(content, []byte(importStmt), header.Bytes(), 1)
		*/
		info, err := d.Info()
		if err != nil {
			return err
		}

		err = os.WriteFile(path, content, info.Mode())
		if err != nil {
			return err
		}

		// fmt.Printf("%s\n", string(content))
		fmt.Printf("%s\n", path)
		return nil
	})
}

// FirstUpper returns a copy of s, where the first rune is
// guaranteed to be an uppercase letter, like unicode.ToUpper
// suggests.
func FirstUpper(s string) string {
	for i, v := range s {
		return string(unicode.ToUpper(v)) + s[i+1:]
	}
	return ""
}
