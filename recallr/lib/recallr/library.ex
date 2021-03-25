defmodule Recallr.Library do
  @moduledoc """
  The Library context.
  """
  @topic "count_change"

  import Ecto.Query, warn: false
  alias Recallr.Repo

  alias Recallr.Library.Passage

  def notify do
    Phoenix.PubSub.broadcast(Recallr.PubSub, @topic, :change)
  end

  def first do
    q = from p in Passage, where: p.id > 0, limit: 1
    q |> Repo.one
  end

  def next(id) do
    (from p in Passage, where: p.id > ^id, order_by: [asc: :id], limit: 1)
    |> Repo.one()
    |> Kernel.||(first())
    |> IO.inspect
    |> Map.get(:id)
  end

  @doc """
  Returns the list of passages.

  ## Examples

      iex> list_passages()
      [%Passage{}, ...]

  """
  def list_passages do
    Repo.all(Passage)
  end

  @doc """
  Gets a single passage.

  Raises `Ecto.NoResultsError` if the Passage does not exist.

  ## Examples

      iex> get_passage!(123)
      %Passage{}

      iex> get_passage!(456)
      ** (Ecto.NoResultsError)

  """
  # Prose.find(socket.assigns.id)
  def get_passage!(id), do: Repo.get!(Passage, id)

  @doc """
  Creates a passage.

  ## Examples

      iex> create_passage(%{field: value})
      {:ok, %Passage{}}

      iex> create_passage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_passage(attrs \\ %{}) do
    result = %Passage{}
    |> Passage.changeset(attrs)
    |> Repo.insert()

    notify()
    result
  end

  @doc """
  Updates a passage.

  ## Examples

      iex> update_passage(passage, %{field: new_value})
      {:ok, %Passage{}}

      iex> update_passage(passage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_passage(%Passage{} = passage, attrs) do
    passage
    |> Passage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a passage.

  ## Examples

      iex> delete_passage(passage)
      {:ok, %Passage{}}

      iex> delete_passage(passage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_passage(%Passage{} = passage) do
    result = Repo.delete(passage)
    notify()
    result
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking passage changes.

  ## Examples

      iex> change_passage(passage)
      %Ecto.Changeset{data: %Passage{}}

  """
  def change_passage(%Passage{} = passage, attrs \\ %{}) do
    Passage.changeset(passage, attrs)
  end
end
