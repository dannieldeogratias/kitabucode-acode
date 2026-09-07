import { defineBundle, defineServer, installers } from "../providerUtils";
import type { LspServerBundle, LspServerManifest } from "../types";

export const pythonServers: LspServerManifest[] = [
	defineServer({
		id: "ty",
		label: "Python (ty)",
		languages: ["python"],
		command: "ty",
		args: ["server"],
		checkCommand: "which ty",
		installer: installers.pip({
			executable: "ty",
			packages: ["ty"],
		}),
		enabled: false,
	}),
	defineServer({
		id: "python",
		label: "Python (pylsp)",
		languages: ["python"],
		command: "pylsp",
		checkCommand: "which pylsp",
		installer: installers.apk({
			executable: "pylsp",
			packages: ["py3-lsp-server", "py3-pyflakes", "py3-pycodestyle", "py3-mccabe"],
		}),
		initializationOptions: {
			pylsp: {
				plugins: {
					pyflakes: { enabled: true },
					pycodestyle: { enabled: true },
					mccabe: { enabled: true },
				},
			},
		},
		enabled: true,
	}),
];

export const pythonBundle: LspServerBundle = defineBundle({
	id: "builtin-python",
	label: "Python",
	servers: pythonServers,
});
