<!-- src/routes/register/+page.svelte -->
<script>
  import { backend } from "$lib/canisters";
  import { goto } from '$app/navigation';

  let name = '';
  let description = '';
  let price = '';
  let link = '';

  async function registerAsset() {
    if (name && description && price && link) {
      try {
        await backend.storeAsset(name, description, parseFloat(price), link);
        goto('/');
      } catch (error) {
        console.error("Error storing asset:", error);
      }
    }
  }
</script>

<h2>Register Asset for Borrowing</h2>
<form on:submit|preventDefault={registerAsset}>
  <input bind:value={name} placeholder="Asset Name" required />
  <input bind:value={description} placeholder="Description" required />
  <input bind:value={price} type="number" placeholder="Price" required />
  <input bind:value={link} placeholder="Asset Link" required />
  <button type="submit">Submit</button>
</form>
<button on:click={() => goto('/')}>Back</button>